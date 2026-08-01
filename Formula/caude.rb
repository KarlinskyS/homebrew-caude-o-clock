class Caude < Formula
  desc "Menu bar app showing Claude Code's 5-hour/weekly usage windows"
  homepage "https://github.com/KarlinskyS/caude-o-clock"
  url "https://github.com/KarlinskyS/caude-o-clock.git", tag: "v0.2.8", revision: "74529b81c299370d5e25708a7cafad8808f1b1d2", using: :git

  depends_on :macos
  depends_on "python@3.12"

  def install
    venv = libexec/"venv"
    system formula_opt_bin("python@3.12")/"python3.12", "-m", "venv", venv
    system venv/"bin/pip", "install", "--upgrade", "pip"
    system venv/"bin/pip", "install", "-r", "requirements-build.txt"
    system venv/"bin/python", "setup.py", "-q", "py2app",
      "--dist-dir", "build-dist", "--bdist-base", "build"

    libexec.install "build-dist/Caude o'clock.app"
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
