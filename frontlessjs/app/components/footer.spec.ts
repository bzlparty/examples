import { describe, it, beforeEach } from "node:test";
import assert from "assert";
import footer from "./footer";
import type { JSDOM } from "jsdom";
import { createComponent } from "@frontless-example/testing";

describe("footer", () => {
  let dom: JSDOM;

  beforeEach(async () => {
    let _;
    [dom, _] = await createComponent(footer);
  });

  it("should show links", () => {
    const links = dom.window.document.querySelectorAll("a");
    assert.notEqual(links.length, 0);
    for (const [i, e] of Array.from(links.entries())) {
      assert.strictEqual(e.href, "about:blank#");
      assert.strictEqual(e.innerHTML, `Link${i + 1}`);
    }
  });

  it("should show text", () => {
    const text = dom.window.document.querySelector("span");
    assert.strictEqual(text?.innerHTML, "/components/footer.ts");
  });
});
