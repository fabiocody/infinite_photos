class PhotoProviderArg {
  final int albumId;
  final int index;

  const PhotoProviderArg({
    required this.albumId,
    required this.index,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final PhotoProviderArg otherArg = other as PhotoProviderArg;
    return otherArg.albumId == albumId && otherArg.index == index;
  }

  @override
  int get hashCode => albumId.hashCode ^ index.hashCode;
}
