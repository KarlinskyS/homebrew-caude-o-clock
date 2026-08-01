class Caude < Formula
  desc "Menu bar app showing Claude Code's 5-hour/weekly usage windows"
  homepage "https://github.com/KarlinskyS/caude-o-clock"
  url "https://github.com/KarlinskyS/caude-o-clock.git", tag: "v0.2.4", revision: "3c85c0d22a17aa0173f0633aa0b9ed037e7d53bf", using: :git

  depends_on :macos
  depends_on "python@3.12"

  def install
    venv = libexec/"venv"
    system formula_opt_bin("python@3.12")/"python3.12", "-m", "venv", venv
    system venv/"bin/pip", "install", "--upgrade", "pip"
    system venv/"bin/pip", "install", "pyobjc-framework-Cocoa"

    libexec.install Dir["*"]

    (bin/"caude").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/caude" "$@"
    EOS
    (bin/"caude").chmod 0755
  end

  test do
    system bin/"caude", "--help"
    system libexec/"venv/bin/python", "-c", "import sys; sys.path.insert(0, '#{libexec}'); import ccusagebar"
  end
end
