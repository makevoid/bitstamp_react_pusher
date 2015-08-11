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
          comp = present Transaction, tx: tx, key: tx[:hash] # TODO: ref
          comp
        end
      end
    end
  end
end
