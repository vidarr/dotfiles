--
--    Copyright (c) 2020 German Aerospace Center DLR e.V. (GSOC)
--
--    Licensed under the Apache License, Version 2.0 (the "License");
--    you may not use this file except in compliance with the License.
--    You may obtain a copy of the License at
--
--            http://www.apache.org/licenses/LICENSE-2.0
--
--    Unless required by applicable law or agreed to in writing, software
--    distributed under the License is distributed on an "AS IS" BASIS,
--    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--    See the License for the specific language governing permissions and
--    limitations under the License.
--
--    This file is part of the openvocs project. https://openvocs.org
--
--------------------------------------------------------------------------------
--
--        @author         Michael J. Beer
--
--        Wireshark plugin to dissect Openvocs RTP Sync Extension Header.
--
--        See src/lib/ov_base/include/ov_rtp_header_sync.h
--
--        Copy this file into your wireshark plugins directory:
--
--        See in wireshark, Menu Help->About Wireshark->Folders
--
--------------------------------------------------------------------------------

sync_header_proto = Proto("RTP_Header_OV_Sync",  "RTP Openvocs Sync Extension Header")

volume = ProtoField.uint8("rtp_header_ov_sync.volume", "volume", base.DEC)
sequence_number = ProtoField.uint16("rtp_header_ov_sync.seq_number", "seq_number", base.DEC)

sync_header_proto.fields = {volume, sequence_number}

function sync_header_proto.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end

    pinfo.cols.protocol = sync_header_proto.name

    for offset = 0, length - 1, 4 do

        local subtree = tree:add(sync_header_proto, buffer(), "Openvocs CSRC Sync Data")

        subtree:add(volume, buffer(offset, 1))
        subtree:add(sequence_number, buffer(offset + 2, 2))

    end

end

--------------------------------------------------------------------------------

local rtp_header = DissectorTable.get("rtp.hdr_ext")

-- 0x7853 is the type id of the openvocs rtp sync extenstion header

rtp_header:add(0x7853, sync_header_proto)

