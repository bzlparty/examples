import { describe, it } from "node:test";
import assert from "assert";
import index from "./index";
import { createComponent } from "@frontless-example/testing";

describe("index", () => {
  it("should show 'Hello!'", async () => {
    const [dom, _] = await createComponent(index);
    const text = dom.window.document.querySelector("span")?.innerHTML;
    assert.strictEqual(text, "Hello!");
  });
});
