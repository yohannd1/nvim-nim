from vimtest import cleanup, startNvim


nvim = startNvim()


def test_opening():
    cleanup(nvim)
    nvim.command("e outline.nim")
    nvim.current.buffer[:] = [
            "var x = 42",
            "type Y = object",
            "    x, y: int"]
    nvim.command(":NimOutline")
    outlinewin = nvim.eval('bufwinnr("__nim_outline__")')
    assert outlinewin > 0
