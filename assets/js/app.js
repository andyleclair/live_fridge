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
window.debounce = (func, timeout = 300) => {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => { func.apply(this, args); }, timeout);
  };
}

const Hooks = {
  Drag: {
    mounted() {
      let initialX = 0;
      let initialY = 0;
      let initialMouseX, initialMouseY, currentX, currentY;

      const me = this;

      const mouseMove = (event) => {
        const newLeft = initialX + (event.pageX - initialMouseX);
        const newTop = initialY + (event.pageY - initialMouseY);

        currentX = newLeft;
        currentY = newTop;

        me.pushEvent("move", { id: me.el.id, x: newLeft, y: newTop });
        me.el.style.left = `${newLeft}px`;
        me.el.style.top = `${newTop}px`;
      }

      this.el.onmousedown = (event) => {
        this.el.classList.remove("cursor-grab");
        this.el.classList.add("cursor-grabbing");
        document.onmousemove = mouseMove;
        initialMouseX = event.pageX;
        initialMouseY = event.pageY;
        initialX = this.el.offsetLeft;
        initialY = this.el.offsetTop;
      }

      this.el.onmouseup = (event) => {
        this.el.classList.remove("cursor-grabbing");
        this.el.classList.add("cursor-grab");
        document.onmousemove = null;
        this.pushEvent("drop", { id: this.el.id, x: currentX, y: currentY });
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

