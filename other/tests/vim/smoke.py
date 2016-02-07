from vimtest import cleanup, startNvim

nvim = startNvim()


def test_buffer():
    cleanup(nvim)
    nvim.command("norm ggdG")
    nvim.command("norm ihello world")
    assert nvim.current.buffer[:] == ["hello world"]


def test_another():
    cleanup(nvim)
    nvim.command("norm ihello world")
    nvim.command("norm ggdG")
    assert nvim.current.buffer[:] == ['']


def test_plugin_loading():
    cleanup(nvim)
    nvim.command("e testi.nim")
    assert nvim.eval("&ft") == "nim"
    assert nvim.eval('exists(":NimUsages")') == 2
