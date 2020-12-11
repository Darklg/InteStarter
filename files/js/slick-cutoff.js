jQuery(document).ready(function($) {
    jQuery('.slider-cutoff').each(function() {
        var $slider = jQuery(this);
        $slider.slick({
            infinite: false,
            slidesToShow: 3,
            slidesToScroll: 3,
            responsive: [{
                breakpoint: 768,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2
                }
            }, {
                breakpoint: 480,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1
                }
            }]
        });
    });
});
