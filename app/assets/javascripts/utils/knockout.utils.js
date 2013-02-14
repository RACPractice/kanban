//connect items with observableArrays
ko.bindingHandlers.sortableList = {
    init: function(element, valueAccessor, allBindingsAccessor, context) {
        var options = valueAccessor();
        var $element = $(element);
        $element.data("sortList", options.list); //attach meta-data
        $element.sortable({
            items: "li:not(.not_sortable)",
            update: function(event, ui) {
                var item = ui.item.data("sortItem");
                if (item) {
                    //identify parents
                    var originalParent = ui.item.data("parentList");
                    var newParent = ui.item.parent().data("sortList");
                    //figure out its new position
                    var position = ko.utils.arrayIndexOf(ui.item.parent().children(), ui.item[0]);
                    if (position >= 0) {
                        originalParent.remove(item);
                        newParent.splice(position, 0, item);
                        ui.item.remove();
                        originalParent.notifySubscribers(item, 'positionsChanged');
                        if (newParent !== originalParent) {
                            newParent.notifySubscribers(item, 'positionsChanged')
                        }
                    }
                }
            },
            connectWith: options.connectWith || '.sortable'
        });
    }
};

//attach meta-data
ko.bindingHandlers.sortableItem = {
    init: function(element, valueAccessor) {
        var options = valueAccessor();
        var $element = $(element);
        $element.data("sortItem", options.item);
        $element.data("parentList", options.parentList);
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

ko.bindingHandlers.drag = {
    init: function (element, valueAccessor, allBindingsAccessor, viewModel) {
        var dragElement = $(element);
        var dragOptions = {
            helper: 'clone',
            revert: true,
            revertDuration: 0,
            start: function () {
                dragElement.data('dragElement', ko.utils.unwrapObservable(valueAccessor().value));
            },
            cursor: 'default'
        };
        dragElement.draggable(dragOptions).disableSelection();
    }
}

ko.bindingHandlers.drop = {
    init: function (element, valueAccessor, allBindingsAccessor, viewModel) {
        var dropElement = $(element);
        var dropOptions = {
            drop: function (event, ui) {
                var member = ui.draggable.data('dragElement');
                valueAccessor().value.droped(member);
            }
        };
        dropElement.droppable(dropOptions);
    }
}
