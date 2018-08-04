(
	define (desaturate-x11-cursor-pattern pattern mode) (

		let* ((filelist (cadr (file-glob pattern 1)))) (

			while (not (null? filelist)) (

				let* ((filename (car filelist)) (

					image (car (gimp-file-load RUN-NONINTERACTIVE filename filename))) (
						drawable (car (gimp-image-get-active-layer image))
					)

				)

				(gimp-context-push)

				(gimp-image-undo-group-start image)

				(map (lambda (x) (gimp-desaturate-full x mode)) (vector->list (cadr (gimp-image-get-layers image))))

				(gimp-image-set-active-layer image drawable)

				(gimp-image-undo-group-end image)

				(gimp-context-pop)

				(gimp-displays-flush)

				(file-xmc-save RUN-NONINTERACTIVE image drawable filename filename -1 -1 0 0 0 0 0 "" "" "")

				(gimp-image-delete image)

			) (
				set! filelist (cdr filelist)
			)
		)
	)
)
