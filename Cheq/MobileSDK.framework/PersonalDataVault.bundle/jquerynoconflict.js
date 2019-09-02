/* 
 * Copyright 2017 eWise Systems, Inc.
 */
(function () {
	eWise.$ = jQuery.noConflict(true);
	
	eWise.highlight = function (elements, color) {
        if (!color) {
            color = 'green';
        }

        elements.wrap('<div class="highlighter"></div>');
    	eWise.$('.highlighter').css('border', '5px solid ' + color);
    };
}());