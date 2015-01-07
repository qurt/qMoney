// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require pikadate/picker.js
//= require pikadate/picker.date
//= require pikadate/translations/ru_RU
//= require highcharts/highcharts
//= require highcharts/highcharts-more
//= require_tree .

var ready = function() {
  var menu = $('header.navigation');

  $('#menu-fade').on('click', function() {
    if(menu.is(':visible')) {
      menu.toggle();
      $(this).hide();
    }
  });
  $('#js-mobile-menu').on('click', function(e) {
    e.preventDefault();
    menu.toggle(function(){
      if(menu.is(':hidden')) {
        menu.removeAttr('style');
      }
      $('#menu-fade').toggle();
    });
  });
  var more_button = $('li.more').find('a');
  more_button.click(function () {
    $(this).parent().find('ul.submenu').toggle();
  });
};

$(document).ready(ready());
$(document).on('page:load', ready());
