window.ShyneService = angular.module('ShyneService', [])
window.ShyneDirectives = angular.module('ShyneDirectives', [])
window.Shyne = angular.module('Shyne', ['angular-blocks', 'ShyneService', 'ShyneDirectives', 'ngRoute', 'ngTagsInput', 'ui.utils', 'xeditable', 'angularMoment'])