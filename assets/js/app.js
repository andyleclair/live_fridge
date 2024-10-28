// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

const Hooks = {
  Drop: {
    mounted() {
      this.el.ondrop = (event) => {
        console.log(event);
        event.preventDefault()
        this.pushEvent('drop', {
          id: event.dataTransfer.getData('text/plain'),
          x: event.clientX - 10,
          y: event.clientY - 10,
        })
      }
    },
  },
  Drag: {
    mounted() {
      this.el.onmousedown = (event) => {
        this.el.classList.remove("cursor-grab");
        this.el.classList.add("cursor-grabbing");
      }

      this.el.onmouseup = (event) => {
        this.el.classList.remove("cursor-grabbing");
        this.el.classList.add("cursor-grab");
      }

      this.el.ondragover = (event) => {
        event.preventDefault()
      },
      this.el.ondragstart = (event) => {
        console.log(event);
        console.log(this.el.id);
        event.dataTransfer.setData('text/plain', this.el.id);
        event.dataTransfer.dropEffect = 'move';
      }
    },
  },
}

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

