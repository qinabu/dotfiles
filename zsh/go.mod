module go.avito.ru/gl/watcher

go 1.17

require (
	github.com/bmatcuk/doublestar v1.3.4
	github.com/google/shlex v0.0.0-20191202100458-e7afc7fbc510
	github.com/rjeczalik/notify v0.9.2
	github.com/rjeczalik/notify_master v0.0.0-00010101000000-000000000000
)

require golang.org/x/sys v0.0.0-20180926160741-c2ed4eda69e7 // indirect

replace github.com/rjeczalik/notify_master => github.com/rjeczalik/notify v0.9.3-0.20210809113154-3472d85e95cd
