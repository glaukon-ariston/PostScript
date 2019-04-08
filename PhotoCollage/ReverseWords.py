import sublime, sublime_plugin

class ReverseWordsCommand(sublime_plugin.TextCommand):
    '''
    http://stackoverflow.com/questions/14574941/add-a-number-to-each-selection-in-sublime-text-2-incremented-once-per-selection
    https://www.sublimetext.com/docs/3/api_reference.html#sublime.View

    Save the file (ReverseWords.py) to Data/Packages/User folder.
    Add this to Preferences|Key Bindings - User
    { "keys": ["ctrl+shift+e"], "command": "reverse_words" }

    Example:
        action value key -> key value action 


    '''
    def run(self, edit):
        for region in self.view.sel():
            s = self.view.substr(region)
            ws = s.split(' ')
            reversedWs = ' '.join(ws[::-1])
            self.view.insert(edit, region.begin(), reversedWs)

            for region in self.view.sel():
                self.view.erase(edit, region)
