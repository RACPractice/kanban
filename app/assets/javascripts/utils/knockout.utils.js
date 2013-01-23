//connect items with observableArrays
ko.bindingHandlers.sortableList = {
    init: function(element, valueAccessor, allBindingsAccessor, context) {
        var options = valueAccessor();
        $(element).data("sortList", options); //attach meta-data
        $(element).sortable({
            update: function(event, ui) {
                var item = ui.item.data("sortItem");
                if (item) {
                    //identify parents
                    var originalParent = ui.item.data("parentList");
                    var newParent = ui.item.parent().data("sortList");
                    //figure out its new position
                    var position = ko.utils.arrayIndexOf(ui.item.parent().children(), ui.item[0]);
                    if (position >= 0) {
                        if (newParent === originalParent) {
                            ko.utils.moveAtPosition(originalParent, item, position);
                            originalParent.notifySubscribers(item, 'itemAdded');
                        } else {
                            originalParent.remove(item);
                            newParent.splice(position, 0, item);
                            ui.item.remove();
                        }
                    }
                }
            },
            connectWith: '.sortable'
        });
    }
};

//attach meta-data
ko.bindingHandlers.sortableItem = {
    init: function(element, valueAccessor) {
        var options = valueAccessor();
        $(element).data("sortItem", options.item);
        $(element).data("parentList", options.parentList);
    }
};

//control visibility, give element focus, and select the contents (in order)
ko.bindingHandlers.visibleAndSelect = {
    update: function(element, valueAccessor) {
        ko.bindingHandlers.visible.update(element, valueAccessor);
        if (valueAccessor()) {
            setTimeout(function() {
                $(element).focus().select();
            }, 0); //new tasks are not in DOM yet
        }
    }
}

ko.utils.moveAtPosition = function(observableArray, element, newPosition) {
    var arr = observableArray();
    var oldIndex = element.position;
    var newIndex = newPosition;
    var start = 0;
    var end = 0;
    if (oldIndex < newIndex) {
        start = oldIndex;
        end = newIndex;
    } else {
        end = oldIndex;
        start = newIndex;
    }
    for (var i=0; i< arr.length; i++) {
        var indexElem = arr[i];
        if (indexElem.position >= start && indexElem.position <= end) {
            indexElem.position += 1;
        }
    }
    element.position = newPosition;
}
