<script>
    (function($) {
        "use strict";

        // Spinner
        var spinner = function() {
            setTimeout(function() {
                if ($("#spinner").length > 0) {
                    $("#spinner").removeClass("show");
                }
            }, 1);
        };
        spinner();

        // // Sticky Navbar
        // $(window).scroll(function() {
        //     if ($(this).scrollTop() > 300) {
        //         $(".sticky-top").addClass("shadow-sm").css("top", "0px");
        //     } else {
        //         $(".sticky-top").removeClass("shadow-sm").css("top", "-100px");
        //     }
        // });

        $('#header-carousel').owlCarousel({
            items: 1,
            loop: true,
            autoplay: true,
            autoplayTimeout: 6000,
            smartSpeed: 5000,
            animateOut: 'fadeOut',
            animateIn: 'fadeIn',
            nav: false,
            dots: false,
            mouseDrag: false,
            touchDrag: false,
            pullDrag: false,
            navText: [
                '<i class="fa fa-chevron-left fs-2 text-primary"></i>',
                '<i class="fa fa-chevron-right fs-2 text-primary"></i>'
            ]
        });

    })(jQuery);
</script>
