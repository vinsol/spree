Spree.disableSaveOnClick = ->
  ($ 'form.edit_order').submit ->
    ($ this).find(':submit, :image').attr('disabled', true).removeClass('primary').addClass 'disabled'

Spree.enableSave = (form) ->
  ($ form).find(':submit, :image').attr('disabled', false).addClass('primary').removeClass 'disabled'

Spree.ready ($) ->
  Spree.Checkout = {}
