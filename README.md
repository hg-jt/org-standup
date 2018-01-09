# org-standup

*org-standup.el* provides a template for creating daily standup notes in
org-mode along with some utilities for navigating between these daily notes.
Each daily standup entry is stored in a separate file in a directory hierarchy
with the following layout:

    .
    └── yyyy
        └── mm
            ├── dd.org
            └── ...


## Installation

    M-x package-install-file <path to org-standup.el>


## Configuration

### Daily Standup Template

The template *org-standup.el* provides leverages *auto-insert-mode*. The
template can be configured by customizing *org-standup-questions* and will be
triggered when you create a file with the following naming convention
`<org-standup-dir>/yyyy/mm/dd.org`.

To register the template and enable *auto-insert-mode*, add the following to
your Emacs configuration:

```elisp
(add-hook 'after-init-hook
          (lambda ()
            ;; initialize the template
            (eval-after-load 'autoinsert #'org-standup-template-init)

            ;; enable auto-insert
            (add-hook 'find-file-hook 'auto-insert)))
```

You can configure the daily entry template by customizing the following variables:

* `org-standup-title-format`

* `org-standup-questions`


### Navigation

There are three commands for opening daily standup entries: `org-standup-today`,
`org-standup-yesterday`, and `org-standup-tomorrow`.


> *NOTE*: `org-standup-today` is autoloaded, so you can bind it to a global key
> binding:
>
> ```elisp
> (define-key global-map (kbd "C-c s") 'org-standup-today)
> ```

There is also a pair of commands for finding the nearest adjacent entry to the
current entry: `org-standup-previous-entry` and `org-standup-next-entry`.


## License

This project is licensed under the [GNU GPL v3](LICENSE).
