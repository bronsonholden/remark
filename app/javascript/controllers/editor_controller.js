import { Controller } from "@hotwired/stimulus"
import { basicSetup } from "codemirror"
import { EditorView, ViewPlugin, keymap } from "@codemirror/view"
import { EditorState } from "@codemirror/state"
import { markdown } from "@codemirror/lang-markdown"
import { indentWithTab } from "@codemirror/commands"

export default class extends Controller {
  static values = {
    container: String,
    readOnly: Boolean
  }

  connect() {
    const source = this.element
    const parent = document.querySelector(this.containerValue)

    if (!parent) {
      return
    }

    // Clear any previous editors
    while (parent.firstChild) {
      parent.removeChild(parent.firstChild)
    }

    this.editor = new EditorView({
      doc: source.textContent,
      extensions: [
        ViewPlugin.fromClass(class {
          update(update) {
            if (update.docChanged) {
              source.textContent = update.state.doc.toString()
            }
          }
        }),
        basicSetup,
        keymap.of([ indentWithTab ]),
        markdown(),
        EditorState.readOnly.of(this.readOnlyValue)
      ],
      parent
    })
  }
}
