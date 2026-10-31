import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


class AgentSourceUpdateTests(unittest.TestCase):
    def test_repairs_selected_revisions_without_changing_manifests(self):
        self.check_update(fail=False)

    def test_failed_skill_refresh_preserves_both_locks(self):
        self.check_update(fail=True)

    def check_update(self, *, fail):
        script = Path(__file__).resolve().with_name("renovate-agent-sources.sh")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            skills = root / "skills/registry/sources.lock.json"
            plugins = root / "omp/plugins/npins/sources.json"
            skill_data = {
                "schemaVersion": 1,
                "manifests": {"pinned": {"pin": {"at": "fixed"}}},
                "npins": {
                    "version": 8,
                    "pins": {
                        "floating": {
                            "revision": "selected-by-renovate",
                            "hash": "stale",
                        },
                        "pinned": {"revision": "fixed", "hash": "hash-for-fixed"},
                    },
                },
            }
            plugin_data = {
                "version": 8,
                "pins": {"plugin": {"revision": "selected-plugin", "hash": "stale"}},
            }
            for path, data in [(skills, skill_data), (plugins, plugin_data)]:
                path.parent.mkdir(parents=True)
                path.write_text(json.dumps(data))
            original_skills, original_plugins = (
                skills.read_bytes(),
                plugins.read_bytes(),
            )

            bin_dir = root / "bin"
            bin_dir.mkdir()
            npins = bin_dir / "npins"
            npins.write_text(
                f"#!{sys.executable}\n"
                "import json, os, pathlib, sys\n"
                "assert sys.argv[-2:] == ['update', '--partial']\n"
                "path = pathlib.Path(sys.argv[2])\n"
                "if sys.argv[1] == '-d': path = path / 'sources.json'\n"
                "if os.environ['FAIL_NPINS'] == 'true':\n"
                "    path.write_text('incomplete output')\n"
                "    sys.exit(1)\n"
                "data = json.loads(path.read_text())\n"
                "for pin in data['pins'].values():\n"
                "    pin['hash'] = 'hash-for-' + pin['revision']\n"
                "path.write_text(json.dumps(data))\n"
            )
            npins.chmod(0o755)
            result = subprocess.run(
                ["bash", str(script)],
                cwd=root,
                env={
                    **os.environ,
                    "PATH": f"{bin_dir}:{os.environ['PATH']}",
                    "FAIL_NPINS": str(fail).lower(),
                },
                capture_output=True,
                text=True,
                check=False,
            )
            if fail:
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(skills.read_bytes(), original_skills)
                self.assertEqual(plugins.read_bytes(), original_plugins)
            else:
                self.assertEqual(result.returncode, 0, result.stderr)
                skill_data["npins"]["pins"]["floating"]["hash"] = (
                    "hash-for-selected-by-renovate"
                )
                plugin_data["pins"]["plugin"]["hash"] = "hash-for-selected-plugin"
                self.assertEqual(json.loads(skills.read_text()), skill_data)
                self.assertEqual(json.loads(plugins.read_text()), plugin_data)
            self.assertEqual(list(skills.parent.glob("sources.lock.json.*")), [])


if __name__ == "__main__":
    unittest.main()
