import { newComponent } from "frontlessjs/component";
import { row, link, text } from "frontlessjs/material";

export default newComponent(
  class {
    render() {
      return row(
        [
          link("#", "Link1"),
          link("#", "Link2"),
          text("/components/footer.ts", { color: "#3ea84c" }),
        ],
        {
          gap: 10,
          mainAxis: "center",
          padding: 10,
          style: { background: "#eee" },
        },
      );
    }
  },
);
