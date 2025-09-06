import lustre
import lustre/element.{type Element}
import lustre/element/html

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type State {
  State(current_dir: String, dirs: List(String), files: List(String))
}

fn init(_args) -> State {
  todo as "call the server and ask for the current dir and files"
}

type Msg {
  UserClickedFile(name: String)
  UserClickedDir(name: String)
}

fn update(state: State, msg: Msg) -> State {
  todo as "call the server for the new files and dirs"
}

fn view(state: State) -> Element(Msg) {
  todo as "render the state"
}
