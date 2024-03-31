import { JSDOM } from "jsdom";
import { initCtx, storeCtx, Ctx } from "frontlessjs/context";
import { createRequest, createResponse } from "node-mocks-http";

export function createComponent(
  cmpFn: () => Promise<string>,
): Promise<[JSDOM, Ctx]> {
  const req = createRequest();
  const res = createResponse();
  const ctx = initCtx(
    req,
    res,
    () => `<div></div>`,
    () => {},
  );
  return new Promise((resolve, reject) => {
    storeCtx(ctx, async () => {
      try {
        const element = await cmpFn();
        const dom = new JSDOM(element);
        resolve([dom, ctx]);
      } catch (e) {
        reject(e);
      }
    });
  });
}
