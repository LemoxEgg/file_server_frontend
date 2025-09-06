import gleam/list
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type State {
  State(current_dir: String, dirs: List(String), files: List(String))
}

fn init(_args) -> #(State, Effect(Msg)) {
  // todo as "call the server and ask for the current dir and files"
  // TEMP basic state to test the app

  #(State(".", ["dir1", "dir2"], ["file1", "file2"]), effect.none())
}

type Msg {
  UserClickedFile(name: String)
  UserClickedDir(name: String)
}

fn update(state: State, msg: Msg) -> #(State, Effect(Msg)) {
  todo as "call the server for the new files and dirs"
}

fn view(state: State) -> Element(Msg) {
  let elements = [
    html.h1([], [html.text("Lem's lil Server")]),
    html.hr([]),
  ]

  let links =
    list.map(state.dirs, fn(x) {
      html.a([attribute.class("directory")], [html.text(x)])
    })
    |> list.append(
      list.map(state.files, fn(x) {
        html.a([attribute.class("file")], [html.text(x)])
      }),
    )
    |> list.intersperse(html.br([]))

  html.div([], list.append(elements, links))
}
