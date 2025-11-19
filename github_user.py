class GithubUser:
    def __init__(self, name: str, followers: int, profile_image_link: str, link: str):
        self.name = name
        self.followers = followers
        self.profile_image_link = profile_image_link
        self.link = link
