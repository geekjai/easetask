/**
 * Display Header Menu
 */
(function ($) {
  'use strict'

  var $mainHeader = $('.main-header')
  $mainHeader.addClass("navbar navbar-expand navbar-dark navbar-purple");

  var $leftNav = $('<ul />', {
    class: 'navbar-nav'
  })

  $mainHeader.append($leftNav)

  $leftNav.append(
    "<li class='nav-item'><a class='nav-link' data-widget='pushmenu' href='#' role='button'><i class='fas fa-bars'></i></a></li>"
  )
  //Home
  $leftNav.append(
    "<li class='nav-item d-none d-sm-inline-block'><a href='/' class='nav-link'>Home</a></li>"
  )
  //TransactionAnalyser
  $leftNav.append(
    "<li class='nav-item d-none d-sm-inline-block'><a href='/transactionAnalyser' class='nav-link'>Transaction Analyser</a></li>"
  )
  var $rightNav = $('<ul />', {
    class: 'navbar-nav ml-auto'
  })

  $mainHeader.append($rightNav)

})(jQuery)
