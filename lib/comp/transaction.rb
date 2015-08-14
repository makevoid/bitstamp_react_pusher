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
