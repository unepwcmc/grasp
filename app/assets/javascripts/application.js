// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require select2

var app = require("app")
app.start()

$(document).ready(function(){
  $(".select2").select2({
      tags: true,
      width: '100%'
  });

  $(".validation__info").click(function(){
    $(this).parent().find('.validation__comments').slideToggle();
    $(this).find('i').toggleClass('fa-chevron-up fa-chevron-down');
  });

  $(".header__menu-button").click(function(){
    $('.header__main-nav').slideToggle();
    $('.header__lower').slideToggle();
  });
})

