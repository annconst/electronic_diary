# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  jQuery('#lesson_date').datetimepicker
    minDate: 0
    timepicker: true
    dateFormat: "yy.mm.dd",
    timeFormat:  "HH:mm"

#  jQuery('#lesson_date').change ->
#    if jQuery(this).val()
#      jQuery('.ui-datepicker').hide()
