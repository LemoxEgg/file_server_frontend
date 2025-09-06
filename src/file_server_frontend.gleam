import gleam/dynamic/decode
import gleam/list
import gleam/string
import gleam/time/timestamp
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import rsvp

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type State {
  State(
    current_dir: String,
    dirs: List(String),
    files: List(String),
    is_loading: Bool,
    load_time: timestamp.Timestamp,
  )
}

fn init(_args) -> #(State, Effect(Msg)) {
  #(State(".", [], [], True, timestamp.system_time()), request_update("."))
}

type Msg {
  UserClickedLink(name: String)
  ApiReturned(Result(#(List(String), List(String)), rsvp.Error))
}

fn update(state: State, msg: Msg) -> #(State, Effect(Msg)) {
  case msg {
    ApiReturned(r) -> {
      case r {
        Error(e) -> todo
        Ok(x) -> {
          #(
            State(state.current_dir, x.0, x.1, False, state.load_time),
            effect.none(),
          )
        }
      }
    }
    UserClickedLink(name:) -> {
      let new_dir = state.current_dir <> "/" <> name
      #(
        State(new_dir, [], [], True, timestamp.system_time()),
        request_update(new_dir),
      )
    }
  }
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

/// requests a new set of directories and files to show on the ui to the server
/// takes the curent directory as an argument and returns a tuple of a list of directories and a list of files
fn request_update(dir: String) -> Effect(Msg) {
  let request = rsvp.expect_json(decode_response(), ApiReturned)

  rsvp.get(dir, request)
}

fn decode_response() -> decode.Decoder(#(List(String), List(String))) {
  use dirs <- decode.field("directories", decode.list(decode.string))
  use files <- decode.field("files", decode.list(decode.string))

  decode.success(#(dirs, files))
}
