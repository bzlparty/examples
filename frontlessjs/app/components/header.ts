import { newComponent } from "frontlessjs/component";
import { row, text } from "frontlessjs/material";

export default newComponent(
  class {
    render() {
      return row(
        [
          text("/components/header.ts", { color: "#3ea84c" }),
          text("user panel here"),
        ],
        {
          mainAxis: "space-between",
          padding: 10,
          style: { background: "#eee" },
        },
      );
    }
  },
);
