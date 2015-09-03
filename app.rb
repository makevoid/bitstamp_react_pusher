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
