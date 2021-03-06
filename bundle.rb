# see this file (the demo app) running: http://bitstamp-react-pusher.mkvd.net

class Log
  def self.l(message)
    `console.log("#{message}")`
  end
end

class Require
  def self.r(package)
    `self.$require("#{package}");`
  end
end

Log.l "antani started!"

Require.r "browser"


module TxFetcher
  WS_ENDPOINT = 'wss://ws.pusherapp.com/app/de504dc5763aeef9ff52?protocol=7&client=js&version=2.1.6&flash=false'

  def load_transactions
    tx_viz = self
    Browser::Socket.new WS_ENDPOINT do
      on :open do
        puts '{ "event": "pusher:subscribe", "data": { "channel": "diff_order_book" } }'
      end

      on :message do |e|
        data = `JSON.parse(e.native.data)`

        if `data.event` == "data"

          data  = `JSON.parse(data.data)`

          bids = `data.bids`
          asks = `data.asks`

          bids = bids.map{ |price, volume| [price.to_f, volume.to_f] }.select{ |price, volume| volume > 0 }
          asks = asks.map{ |price, volume| [price.to_f, volume.to_f] }.select{ |price, volume| volume > 0 }
          
          # log all the things:
          # console.log('bids', bids)`
          # console.log('asks', asks)`

          tx_viz.bids = (tx_viz.bids + bids).sort_by{ |price, volume| -price } unless bids.empty?
          tx_viz.asks = (tx_viz.asks + asks).sort_by{ |price, volume| price  } unless asks.empty?
          
          # < see 3a1bd6c82
        end
      end
    end
  end
end

class Transaction
  include React::Component

  def render
    width = params[:volume].round 1
    width = "#{width}%"
    `
      var divStyle = {
        width: width
      }
    `
    div style: `divStyle` do
      "#{params[:price]} USD - #{params[:volume]} BTC"
    end
  end
end

class TxViz
  include React::Component
  include TxFetcher
  after_mount :load_transactions
  after_mount :reset_timer

  define_state(:timer)        { `new Date()` }
  define_state(:bids) { [] }
  define_state(:asks) { [] }

  def reset_timer
    self.timer = `new Date()`
  end

  def render
    div do
      div className: "header" do
        h3 { "Bitstamp Orderbook live trades" }
        p className: "mini" do
          "realtime orderbook trades visualizer, bitstamp - powered by opal, react, css3, websockets"
        end
      end

      div className: "tx_list row" do
        section className: "bids three columns" do
          h3 { "Bids" }
          self.bids.each_with_index.map do |trade, idx|
            price, volume = trade
            comp = present Transaction, price: price, volume: volume, key: "bid-#{idx}"
            comp
          end
        end
        section className: "asks three columns" do
          h3 { "Asks" }
          self.asks.each_with_index.map do |trade, idx|
            price, volume = trade
            comp = present Transaction, price: price, volume: volume, key: "ask-#{idx}"
            comp
          end
        end
      end
    end
  end
end

`console.log("loading app.rb")`

content = `document.querySelector('.content')`

`content.innerHTML = 'asd'`

`console.log(content.innerHTML)`

React.render(
  React.create_element(TxViz),
  # $document.body.to_n
  # $document.querySelector ".content"
  `content`
)
