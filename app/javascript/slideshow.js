document.addEventListener("DOMContentLoaded", function () {
    $('.bxslider').bxSlider({
        mode: 'horizontal',          // You can change the mode to 'horizontal', 'fade', or 'vertical'
        captions: true,        // Enable captions for the images
        auto: true,            // Automatically start the slideshow
        slideWidth: 600,       // Set the width of each slide
        adaptiveHeight: true,  // Adjust the height based on the image
        pager: true,           // Enable navigation pager
        controls: true,        // Show prev/next controls
        speed: 500,            // Transition speed
        pause: 4000,           // Time between each slide
    });
});