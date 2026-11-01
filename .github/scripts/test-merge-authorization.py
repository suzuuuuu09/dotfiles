import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("merge-authorization.sh")


class MergeAuthorizationTest(unittest.TestCase):
    def handle(
        self,
        action,
        *,
        number=123,
        event_label="automerge",
        event_labels=None,
        api_error=False,
        expect_failure=False,
        expect_no_api=False,
        **changes,
    ):
        with tempfile.TemporaryDirectory() as directory:
            temporary = Path(directory)
            event = temporary / "event.json"
            calls = temporary / "calls.jsonl"
            api_calls = temporary / "api-calls.jsonl"
            gh = temporary / "gh"
            if event_labels is None:
                event_labels = [] if action == "unlabeled" else ["automerge"]
            event.write_text(
                json.dumps(
                    {
                        "action": action,
                        "number": number,
                        "label": {"name": event_label},
                        "pull_request": {
                            "labels": [{"name": label} for label in event_labels]
                        },
                    }
                )
            )
            gh.write_text(
                """#!/usr/bin/env python3
import json
import os
import sys

args = sys.argv[1:]
if args[:1] == ['api']:
    with open(os.environ['TEST_API_CALLS'], 'a') as output:
        output.write(json.dumps(args) + '\\n')
if args == ['api', 'repos/example/dotfiles/pulls/123']:
    if os.environ['TEST_API_ERROR'] == '1':
        sys.exit(1)
    print(os.environ['TEST_PULL_REQUEST'])
elif args[:2] == ['pr', 'merge']:
    with open(os.environ['TEST_CALLS'], 'a') as output:
        output.write(json.dumps(args) + '\\n')
else:
    sys.exit(1)
"""
            )
            gh.chmod(0o755)
            pull_request = {
                "state": "open",
                "draft": False,
                "head": {"repo": {"full_name": "example/dotfiles"}, "sha": "abc123"},
                "base": {"ref": "main"},
                "labels": [{"name": "automerge"}],
                "auto_merge": None,
            }
            pull_request.update(changes)
            environment = {
                **os.environ,
                "PATH": f"{temporary}{os.pathsep}{os.environ['PATH']}",
                "GH_REPO": "example/dotfiles",
                "GITHUB_EVENT_PATH": str(event),
                "TEST_API_CALLS": str(api_calls),
                "TEST_CALLS": str(calls),
                "TEST_API_ERROR": "1" if api_error else "0",
                "TEST_PULL_REQUEST": json.dumps(pull_request),
            }

            result = subprocess.run(
                ["bash", str(SCRIPT)],
                capture_output=True,
                check=False,
                env=environment,
                text=True,
            )

            if expect_failure:
                self.assertNotEqual(result.returncode, 0)
            else:
                self.assertEqual(result.returncode, 0, result.stderr)
            if expect_no_api:
                self.assertFalse(api_calls.exists())
            return (
                [json.loads(line) for line in calls.read_text().splitlines()]
                if calls.exists()
                else []
            )

    def test_label_grants_auto_merge_for_the_current_commit(self):
        self.assertEqual(
            self.handle("labeled"),
            [
                [
                    "pr",
                    "merge",
                    "123",
                    "--auto",
                    "--squash",
                    "--match-head-commit",
                    "abc123",
                ]
            ],
        )

    def test_label_removal_revokes_a_pending_merge(self):
        workflow = (SCRIPT.parent.parent / "workflows/renovate-merge.yaml").read_text()
        self.assertIn("  pull_request_target:", workflow)
        self.assertRegex(workflow, r"(?m)^    types: \[[^\n]*\bunlabeled\b")
        self.assertNotRegex(
            workflow, r"github\.event\.(?:action|label|pull_request\.labels)"
        )
        self.assertIn("run: bash .github/scripts/merge-authorization.sh", workflow)

        self.assertEqual(
            self.handle("unlabeled", labels=[], auto_merge={"enabled_by": "app"}),
            [["pr", "merge", "123", "--disable-auto"]],
        )

    def test_draft_pr_is_not_scheduled(self):
        self.assertEqual(self.handle("labeled", draft=True), [])

    def test_fork_pr_is_not_modified(self):
        self.assertEqual(
            self.handle(
                "unlabeled",
                head={"repo": {"full_name": "fork/dotfiles"}, "sha": "abc123"},
                labels=[],
                auto_merge={"enabled_by": "someone"},
            ),
            [],
        )

    def test_existing_reservation_is_not_recreated(self):
        self.assertEqual(
            self.handle("synchronize", auto_merge={"enabled_by": "app"}), []
        )

    def test_closed_or_retargeted_pr_is_not_modified(self):
        for changes in ({"state": "closed"}, {"base": {"ref": "another-branch"}}):
            with self.subTest(changes=changes):
                self.assertEqual(self.handle("synchronize", **changes), [])

    def test_unlabeled_pr_without_a_reservation_is_unchanged(self):
        self.assertEqual(self.handle("unlabeled", labels=[]), [])

    def test_label_removal_revokes_a_pending_draft_pr(self):
        self.assertEqual(
            self.handle(
                "unlabeled", draft=True, labels=[], auto_merge={"enabled_by": "app"}
            ),
            [["pr", "merge", "123", "--disable-auto"]],
        )

    def test_readded_label_is_read_from_the_current_pr(self):
        self.assertEqual(
            self.handle("unlabeled"),
            [
                [
                    "pr",
                    "merge",
                    "123",
                    "--auto",
                    "--squash",
                    "--match-head-commit",
                    "abc123",
                ]
            ],
        )

    def test_api_failure_does_not_modify_a_pr(self):
        self.assertEqual(
            self.handle("labeled", api_error=True, expect_failure=True), []
        )

    def test_malformed_labels_do_not_cancel_a_reservation(self):
        self.assertEqual(
            self.handle(
                "unlabeled",
                labels=None,
                auto_merge={"enabled_by": "app"},
                expect_failure=True,
            ),
            [],
        )

    def test_invalid_event_number_does_not_modify_a_pr(self):
        self.assertEqual(
            self.handle(
                "labeled", number="123/merge", expect_failure=True, expect_no_api=True
            ),
            [],
        )

    def test_unrelated_label_removal_does_not_cancel_a_manual_reservation(self):
        self.assertEqual(
            self.handle(
                "unlabeled",
                event_label="documentation",
                labels=[],
                auto_merge={"enabled_by": "human"},
                expect_no_api=True,
            ),
            [],
        )


if __name__ == "__main__":
    unittest.main()
