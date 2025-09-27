import time
import os

"""
Rename all & everywhere script
- files, dirs, classes, structs, enums, entities, etc. in whole project, quickly
"""

DIR = os.getcwd()


def replace(old_name, new_name):
    try:
        print('Renaming... ⏳')
        start = time.time()

        for subdir, dirs, files in os.walk(DIR, topdown=False):
            def update(file):
                new_contents = None
                path = f'{subdir}/{file}'

                # --- replace files contents ---
                with open(f'{path}', 'r') as f:
                    new_contents = f.read().replace(old_name, new_name)
                    f.close()

                if new_name in new_contents:
                    with open(f'{path}', 'w') as f2:
                        f2.write(new_contents)
                        f2.close()

                # --- rename files ---
                if old_name in file:
                    new_file = file.replace(old_name, new_name)
                    new_path = os.path.join(subdir, new_file)
                    os.rename(path, new_path)

            for file in files:
                name = os.path.splitext(file)
                _format = name[1]

                if _format in ('.swift', '.strings'):
                    update(file)

            # --- rename dirs ---
            for d in dirs:
                if old_name in d:
                    old_path = os.path.join(subdir, d)
                    new_d = d.replace(old_name, new_name)
                    new_path = os.path.join(subdir, new_d)
                    os.rename(old_path, new_path)

        finish = time.time()
        spent = finish - start
        print(f'✅ Success! Done for {round(spent, 3)} sec.')

    except BaseException as e:
        print(f'💥 Failure! Error: {e}')


def interact():
    old_name = None
    new_name = None

    while not old_name:
        old_name = input('Enter old entity name: \n')

    correct = input(f'Is "{old_name}" correct? ("y" / "n")\n')

    match correct:
        case 'y':
            while not new_name:
                new_name = input('Enter new entity name: \n')
            replace(old_name, new_name)
        case 'n':
            interact()
        case _:
            interact()


if __name__ == '__main__':
    interact()
