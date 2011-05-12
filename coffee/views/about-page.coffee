class Views.AboutPage extends Views.View
  template: _.template('
    <h2>About</h2>

    <p>
      <strong>nnnnext</strong> is a todo list for your music, created to
      fulfil my specific desires: keep track of everything I think I ought
      to listen to, play around with some fun client-side technologies and
      avoid doing anything wholesome with my time.
    </p>

    <p>
      My name&rsquo;s <a href="http://www.aanandprasad.com/" target="_blank">Aanand</a>
      by the way, and I&rsquo;d love to
      <a href="mailto:aanand.prasad@gmail.com">hear from you</a>.
    </p>

    <button class="dismiss"/>
  ')

  render: ->
    $(@el).html(@template())

    @$(".dismiss").click (e) =>
      e.preventDefault()
      @trigger("dismiss")

    this

