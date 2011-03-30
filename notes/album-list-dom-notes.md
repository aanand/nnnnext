Things that necessitate manipulation of an AlbumList's DOM content
------------------------------------------------------------------

- Populating from the localStorage collection
  - Doesn't hurt to empty this.el, but not necessary
  - For each model:
    - Create an AlbumView
    - Render the view
    - Set model.view = the view
    - Show/hide view as necessary (!)
    - Append its element to this.el

- Populating a search results list
  - Empty this.el
  - For each model:
    - Create an AlbumView
    - Render the view
    - Set model.view = the view
    - Append its element to this.el

- Switching between Current and Archived
  - For each model:
    - Show/hide model.view as necessary

- Adding an album to the localStorage collection
  - Create AlbumView, set model.view, render
  - Show/hide view as necessary
  - Insert element in correct location

- Updating of a saved album's state
  - Re-render model.view
  - Show/hide view as necessary
  - Move element to correct location

