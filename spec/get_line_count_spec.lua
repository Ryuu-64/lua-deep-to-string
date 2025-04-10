package.path = package.path .. ";../src/org/ryuu/deeptostring/string/?.lua"
local get_line_count = require "org.ryuu.deeptostring.string.get_line_count"

describe("Line Counter Function Test Suite", function()
    --region Core functionality tests
    it("should return 0 for empty string input", function()
        assert.equal(0, get_line_count(""))
    end)

    it("should count single-line content correctly", function()
        assert.equal(1, get_line_count("Hello World"))
        assert.equal(1, get_line_count("  Leading/trailing spaces  "))
    end)
    --endregion

    --region  Multi-line scenarios
    describe("Multi-line Content Handling", function()
        it("should count LF newlines (Unix-style)", function()
            assert.equal(3, get_line_count("Line1\nLine2\nLine3"))
        end)

        it("should count CRLF newlines (Windows-style)", function()
            assert.equal(2, get_line_count("First\r\nSecond"))
        end)

        it("should handle trailing newline characters", function()
            assert.equal(1, get_line_count("Ends with newline\n"))
            assert.equal(2, get_line_count("First\nSecond\n"))
        end)
    end)
    --endregion

    --region Edge case validations
    it("should skip empty lines between content", function()
        assert.equal(2, get_line_count("Text\n\nSeparated"))
        assert.equal(3, get_line_count("A\n\nB\n\nC"))
    end)

    it("should process mixed newline formats", function()
        assert.equal(4, get_line_count("Unix\nWindows\r\nMixed\nLine"))
    end)
    --endregion

    --region Special character cases
    it("should count lines with special characters", function()
        assert.equal(1, get_line_count("!@#$%^&*()"))
        assert.equal(2, get_line_count("中文\n日本語"))
    end)
    --endregion
end)
