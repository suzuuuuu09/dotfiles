cask "azoo-key-skkserv" do
  version "0.4.0"
  sha256 "b5935f4e3226f8af232a778ce083ad823075bee4ff2e7ad71f6a9d634dfef370"

  url "https://github.com/gitusp/azoo-key-skkserv/releases/download/v#{version}/azoo-key-skkserv-#{version}.dmg"
  name "azooKey skkserv"
  desc "SKK server helper for azooKey"
  homepage "https://github.com/gitusp/azoo-key-skkserv"

  app "azooKey skkserv.app"

  zap trash: [
    "~/Library/Containers/io.github.gitusp.azoo-key-skkserv",
    "~/Library/Preferences/io.github.gitusp.azoo-key-skkserv.plist",
  ]
end
