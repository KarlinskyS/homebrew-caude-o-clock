class Caude < Formula
  desc "Menu bar app showing Claude Code's 5-hour/weekly usage windows"
  homepage "https://github.com/KarlinskyS/caude-o-clock"
  url "https://github.com/KarlinskyS/caude-o-clock.git", tag: "v0.3.0", revision: "5ae8cdd45b72090331a0d6b9d08c76735d6fdbee", using: :git

  depends_on :macos

  def install
    app = libexec/"Caude o'clock.app"
    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    system "/usr/bin/swiftc", "native/CaudeOClock.swift",
      "-framework", "AppKit",
      "-framework", "Foundation",
      "-o", app/"Contents/MacOS/Caude o'clock"
    (app/"Contents/Info.plist").write File.read("native/Info.plist")
    (app/"Contents/Resources/app-icon.icns").write File.binread("assets/app-icon.icns")
    libexec.install "caude"

    (bin/"caude").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/caude" "$@"
    EOS
    (bin/"caude").chmod 0755
  end

  test do
    system bin/"caude", "--help"
    assert_predicate libexec/"Caude o'clock.app/Contents/MacOS/Caude o'clock", :executable?
  end
end
