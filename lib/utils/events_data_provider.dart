import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/model/event_model.dart';

List<EventModel> events = [
  EventModel(
      name: 'Family Meeting Annually 2nd',
      address: 'Số 128 Đường Lê Quang Đạo, Phường Mỹ An, Quận Ngũ Hành Sơn, TP. Đà Nẵng',
      time: '2012-02-27 13:27:00',
      images: [
        NetworkImage('https://picsum.photos/200/300'),
        NetworkImage('https://picsum.photos/1140/703'),
        NetworkImage('https://picsum.photos/1200/675'),
      ],
      latitude: 16.049331,
      longitude: 108.245694
  ),
  EventModel(
      name: 'Funeral',
      address: 'Tổ 5, Thôn Phú Lộc, Xã Hòa Khánh Đông, Huyện Đức Hòa, Tỉnh Long An',
      time: '2020-03-14 11:22:00',
      images: [
        NetworkImage('https://picsum.photos/300'),
        NetworkImage('https://picsum.photos/300/450'),
        NetworkImage('https://picsum.photos/271/644'),
      ],
      latitude: 10.870881,
      longitude: 106.623743
  ),
  EventModel(
      name: 'Death Anniversary of Grand Father',
      address: 'Số 23/4A Đường Trần Hưng Đạo, Phường 1, TP. Mỹ Tho, Tỉnh Tiền Giang',
      time: '2021-06-10 09:00:00',
      images: [
        NetworkImage('https://picsum.photos/300/250'),
        NetworkImage('https://picsum.photos/250'),
        NetworkImage('https://picsum.photos/244/400'),
      ],
      latitude: 10.357056,
      longitude: 106.352201
  ),
  EventModel(
      name: 'Wedding of Cousin Sister',
      address: 'Số 75 Đường Trần Phú, Phường Lộc Thọ, TP. Nha Trang, Tỉnh Khánh Hòa',
      time: '2023-11-25 16:30:00',
      images: [
        NetworkImage('https://picsum.photos/336/280'),
        NetworkImage('https://picsum.photos/180/150'),
        NetworkImage('https://picsum.photos/720/300'),
      ],
      latitude: 12.244052,
      longitude: 109.194572
  ),
  EventModel(
      name: "Ancestor's death anniversary",
      address: 'Số 42 Ngõ 189 Hoàng Hoa Thám, Phường Ngọc Hà, Quận Ba Đình, Hà Nội',
      time: '2024-01-15 10:15:00',
      images: [
        NetworkImage('https://picsum.photos/468/60'),
        NetworkImage('https://picsum.photos/88/31'),
        NetworkImage('https://picsum.photos/120/90'),
      ]
  ),
  EventModel(
      name: 'Inauguration ceremony of the family church',
      address: 'Số 9 Đường Nguyễn Văn Linh, Phường Bình Hiên, Quận Hải Châu, TP. Đà Nẵng',
      time: '2024-05-05 14:00:00',
      images: [
        NetworkImage('https://picsum.photos/120/60'),
        NetworkImage('https://picsum.photos/120/240'),
        NetworkImage('https://picsum.photos/125/125'),
      ]
  ),
  EventModel(
      name: 'Meeting to encourage learning and talent',
      address: 'Số 16A Đường Phạm Ngũ Lão, Phường 3, TP. Đà Lạt, Tỉnh Lâm Đồng',
      time: '2024-08-20 09:30:00',
      images: [
        NetworkImage('https://picsum.photos/728/90'),
      ]
  ),
];
