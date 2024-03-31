import { LitElement, html } from "lit";
import { customElement } from "lit/decorators";

@customElement("lit-simple-app")
export class App extends LitElement {
  render() {
    return html`<p>Hello, World!</p>`;
  }
}
