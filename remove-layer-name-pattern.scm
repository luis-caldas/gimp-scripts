(
	define (remove_layer_name_pattern pattern regex_delete_pattern) (

		let* ((filelist (cadr (file-glob pattern 1)))) (

			while (not (null? filelist)) (

				let* (

					(filename (car filelist))

					(image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))

				)

				(gimp-context-push)

				(gimp-image-undo-group-start image)

				(map (lambda (index-layer-id)

						(let*
							(
								(layer-now-name (gimp-item-get-name index-layer-id))
							)

							(print layer-now-name)

							(if (re-match regex_delete_pattern (car layer-now-name))

					        	(gimp-image-remove-layer image index-layer-id)

							)

						)

					) (vector->list (cadr (gimp-image-get-layers image)))
				)

				(let*
					(
						(drawable (car (gimp-image-get-active-layer image)))
					)

					(gimp-image-set-active-layer image drawable)

					(gimp-image-undo-group-end image)

					(gimp-context-pop)

					(gimp-displays-flush)

					(file-xmc-save RUN-NONINTERACTIVE image drawable filename filename -1 -1 0 0 0 0 0 "" "" "")

					(gimp-image-delete image)

				)

			)

			(set! filelist (cdr filelist))

		)
	)
)
