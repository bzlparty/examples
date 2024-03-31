import { newPage } from "frontlessjs/component";
import { center, row, icon, column, text } from "frontlessjs/material";

export default newPage(
  class {
    render() {
      return center(
        row([
          icon("hand-waving", { size: "2x" }),
          column([
            text("Hello!", { size: "2x" }),
            text("/pages/index.ts", { color: "#3ea84c" }),
          ]),
        ]),
      );
    }
  },
);
