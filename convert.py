from genericpath import isdir, isfile
import cv2
import sys
import os

def convert_video(video_path, output_dir):
    # output dir
    image_output_dir = os.path.basename(video_path).split(".")[0].replace("_", "")
    image_output_dir = os.path.join(output_dir, image_output_dir)
    os.mkdir(image_output_dir)


    vidcap = cv2.VideoCapture(video_path)
    success, image = vidcap.read()
    count = 0
    while success:
        print("Converting frame %d" % count, end="\r")
        frame_name = "{:04d}.jpg".format(count)
        cv2.imwrite(
            os.path.join(image_output_dir, frame_name), image
        )  # save frame as JPEG file
        success, image = vidcap.read()
        count += 1

    print(f"Succesfully converted {count} frames in video {image_output_dir}")

    return f"{os.path.basename(image_output_dir)}, {count}\n"

def remove_and_remake_dir(path):
    if os.path.exists(path):
        for file in os.listdir(path):
            os.remove(os.path.join(path, file))
        # delete
        os.rmdir(path)

    os.mkdir(path)

if __name__ == "__main__":
    args = sys.argv
    # get video path
    path = args[1]

    if os.path.isdir(path):
        # create output dir in the folder
        output_dir = os.path.join(path, "output")
        os.mkdir(output_dir)
        output_csv = os.path.join(output_dir, "output.csv")
        with open(output_csv, "w") as f:
            for file in os.listdir(path):
                if file.endswith(".mp4"):
                    new_line = convert_video(os.path.join(path, file), output_dir)
                    f.write(new_line)
    elif os.path.isfile(path) and path.endswith(".mp4"):
        convert_video(path)
    else:
        print("Invalid video path")