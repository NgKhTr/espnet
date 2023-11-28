import os

VLSP_PATH = '/kaggle/input/vin-big-data-vlsp-2020-100h/vlsp2020_train_set_02'
RANDOM_STATE = 21522717

file_names = os.listdir(VLSP_PATH)
list_utt_id = [file_name[:-4] for file_name in file_names if file_name[-4:] == '.txt']

from sklearn.model_selection import train_test_split

train_utt_id, val_test_utt_id = train_test_split(list_utt_id, train_size=0.8, random_state = RANDOM_STATE)
val_utt_id, test_utt_id = train_test_split(val_test_utt_id, train_size=0.5, random_state = RANDOM_STATE)

def process_data(folder_contain, list_utt_id: list):
    # wav.scp: Mappinng a utterance-ID to a path of audio file
    list_utt_id.sort() # sort r ở đây r nè
    with open(f"data/{folder_contain}/wav.scp", 'w') as file:
        lst = list(map(lambda utt_id: f'{utt_id} {VLSP_PATH}/{utt_id}.wav\n', list_utt_id))
        file.writelines(lst)

    # text: Mapping a utterance-ID to a text
    def read_utt(utt_id):
        res = ''
        with open(f'{VLSP_PATH}/{utt_id}.txt', 'r') as text:
            res = text.read()
        return res
    with open(f'data/{folder_contain}/text', 'w') as file:
        lst = list(map(lambda utt_id: f'{utt_id} {read_utt(utt_id)}\n', list_utt_id))
        file.writelines(lst)

    # spk2utt: Mapping a speaker-ID to a list of utter/ance-IDs
        # do chỉ có 1 th speaker
    speaker_name = 'spk'
    with open(f'data/{folder_contain}/spk2utt', 'w') as file:
        txt_list_utt_id = ' '.join(list_utt_id)
        file.write(f'{speaker_name} {txt_list_utt_id}')

    # utt2spk: Mappinng a utterance-ID to a speaker-ID
    with open(f"data/{folder_contain}/utt2spk", 'w') as file:
        lst = list(map(lambda utt_id: f'{utt_id} {speaker_name}\n', list_utt_id))
        file.writelines(lst)

process_data('train', train_utt_id)
process_data('test', test_utt_id)
process_data('valid', val_utt_id)

# with open('data/train/wav.scp', 'r') as file:
#     print('Train sample amount:', len(file.readlines()))
# with open('data/test/wav.scp', 'r') as file:
#     print('Test sample amount:', len(file.readlines()))
# with open('data/valid/wav.scp', 'r') as file:
#     print('Valid sample amount:', len(file.readlines()))