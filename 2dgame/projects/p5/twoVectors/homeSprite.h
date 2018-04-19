#ifndef HOMESPRITE_H
#define HOMESPRITE_H

#include <string>
#include "multisprite.h"

class HomeSprite : public MultiSprite {
public:
  HomeSprite(const std::string&);
  HomeSprite(const HomeSprite&);
  HomeSprite& operator=( const HomeSprite& );
  virtual ~HomeSprite() { }

  virtual void update(Uint32 ticks);

  void stop();
  void shake();

private:
  std::vector<Image *> stopImgs;
  std::vector<Image *> shakeImgs;

  unsigned lastFrame;
};

#endif
