class Caude < Formula
  desc "Menu bar app showing Claude Code's 5-hour/weekly usage windows"
  homepage "https://github.com/KarlinskyS/caude-o-clock"
  url "https://github.com/KarlinskyS/caude-o-clock.git", tag: "v0.3.1", revision: "1b2890fd85a81e0524b6a81d170aa90ec6de6e32", using: :git

  depends_on :macos

  def install
    app = libexec/"Caude o'clock.app"
    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    system "/usr/bin/swiftc", "native/CaudeOClock.swift",
      "-parse-as-library",
      "-framework", "AppKit",
      "-framework", "Foundation",
      "-framework", "SwiftUI",
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
