`console.log("loading app environment")`

`self.$require("browser");`

module TxFetcher
  def load_transactions
    tx_viz = self
    Browser::Socket.new 'wss://ws.blockchain.info/inv' do
      on :open do
        puts '{"op":"unconfirmed_sub"}'
      end

      on :message do |e|
        data  = `JSON.parse(e.native.data).x`
        out   = `data.out`
        hash  = `data.hash`
        value = out.map{ |o| `o.value` / 10 ** 8 }.inject :+
        value = value.round 8
        tx    = { value: value, hash: hash }

        comp_num = 100
        tx_gone = tx_viz.transactions[comp_num+1]

        if tx_gone
          reactid = ".0.3.$#{tx_gone[:hash]}"
          elem_gone = `document.querySelector("div[data-reactid='"+reactid+"']")`
          `React.unmountComponentAtNode(elem_gone)`
        end

        tx_viz.transactions = [tx] + tx_viz.transactions[0..comp_num]
        tx_viz.total_value  = tx_viz.total_value + value
      end
    end
  end
end

class Transaction
  include React::Component

  def tx_url(tx_hash)
    "https://blockchain.info/tx/#{tx_hash}"
  end

  def render
    element = a href: tx_url(params[:tx][:hash]) do
      "#{params[:tx][:value]} BTC"
      # TODO:
      #
      # n. output
      # type (apply color)
    end

    width = params[:tx][:value].round
    width = "#{width}%"
    `
      var divStyle = {
        width: width
      }
    `
    div style: `divStyle` do
      element
    end
  end
end

class TxViz
  include React::Component
  include TxFetcher
  after_mount :load_transactions
  after_mount :reset_timer

  define_state(:timer)        { `new Date()` }
  define_state(:transactions) { [] }
  define_state(:total_value)  { 0 }

  def reset_timer
    self.timer = `new Date()`
  end

  def render
    div do
      div className: "header" do
        h3 { "Transactions" }
        p className: "mini" do
          "realtime transactions visualizer, bitcoin network - opal, react, css3, websockets, bitcoin, blockchain, blockchain.com, bitcoind"
        end
      end
      div className: "right_panel" do
        div className: "watch_address" do
          label htmlFor: "watch_address" do
            "Address to watch: "
          end
          input id: "watch_address", placeholder: "1address..."

        end
        div className: "theme colors" do
          p { "theme colors" }
          p { "[  ] light" }
          p { "[ x ] color" }
          p { "[  ] dark" }
          p { "[  ] desaturated" }
          p { "[  ] invert" }
          p { "display" }
          p { "[ btc / mbtc / bits / satoshis ] unit" }
        end
        div className: "filters" do
          p { "filters" }
          p { "[ x ] small transactions (<1 BTC)" }
          p { "[  ] "  }
        end
      end
      div className: "status" do
        elapsed = `new Date()` - self.timer
        minutes = (elapsed / 60).floor
        seconds = elapsed - minutes*60
        btc_min = self.total_value / elapsed
        "#{self.total_value.floor} BTC transacted in #{minutes} minutes and #{seconds.floor} seconds (#{btc_min.round(1)} BTC/minute)"
      end
      div className: "tx_list" do
        self.transactions.each_with_index.map do |tx, idx|
          comp = present Transaction, tx: tx, key: tx[:hash]
          comp
        end
      end
    end
  end
end

`console.log("loading app.rb")`

React.render(
  React.create_element(TxViz),
  $document.body.to_n
  # $document.getElementById "container"
)
