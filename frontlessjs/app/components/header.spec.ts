import { describe, it } from "node:test";
import assert from "assert";
import header from "./header";
import { createComponent } from "@frontless-example/testing";

describe("header", () => {
  it("should show links", async () => {
    const [dom, _] = await createComponent(header);
    const spans = dom.window.document.querySelectorAll("span");
    const expectedTexts = ["/components/header.ts", "user panel here"];
    assert.notEqual(spans.length, 0);
    for (const [i, e] of Array.from(spans.entries())) {
      assert.strictEqual(e.innerHTML, expectedTexts[i]);
    }
  });
});
